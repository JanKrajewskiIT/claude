# Placement Algorithm

## Types

```ts
type Side = 'top' | 'bottom' | 'left' | 'right';
type Align = 'start' | 'center' | 'end';
interface Box { left: number; top: number; width: number; height: number }
interface Size { width: number; height: number }
interface Options { side: Side; align: Align; offset: number; padding: number }
```

## Pure Placement

```ts
const OPPOSITE: Record<Side, Side> = { top: 'bottom', bottom: 'top', left: 'right', right: 'left' };
const vertical = (side: Side) => side === 'top' || side === 'bottom';
const clamp = (v: number, min: number, max: number) => Math.max(min, Math.min(v, Math.max(min, max)));

const crossStart = (anchorStart: number, anchorSize: number, size: number, align: Align) =>
  align === 'start' ? anchorStart : align === 'end' ? anchorStart + anchorSize - size : anchorStart + (anchorSize - size) / 2;

const mainStart = (a: Box, s: Size, side: Side, offset: number) =>
  side === 'top' ? a.top - s.height - offset
  : side === 'bottom' ? a.top + a.height + offset
  : side === 'left' ? a.left - s.width - offset
  : a.left + a.width + offset;

const overflow = (a: Box, s: Size, vp: Size, side: Side, o: Options) => {
  const start = mainStart(a, s, side, o.offset);
  const length = vertical(side) ? s.height : s.width;
  const limit = vertical(side) ? vp.height : vp.width;
  return Math.max(0, o.padding - start) + Math.max(0, start + length - (limit - o.padding));
};

export const placeFloating = (a: Box, s: Size, vp: Size, o: Options) => {
  const first = overflow(a, s, vp, o.side, o);
  const flipped = OPPOSITE[o.side];
  const side = first > 0 && overflow(a, s, vp, flipped, o) < first ? flipped : o.side;
  const main = mainStart(a, s, side, o.offset);
  if (vertical(side)) {
    return { side, x: clamp(crossStart(a.left, a.width, s.width, o.align), o.padding, vp.width - s.width - o.padding), y: clamp(main, o.padding, vp.height - s.height - o.padding) };
  }
  return { side, x: clamp(main, o.padding, vp.width - s.width - o.padding), y: clamp(crossStart(a.top, a.height, s.height, o.align), o.padding, vp.height - s.height - o.padding) };
};
```

## Containing Block Origin

```ts
const createsBlock = (st: CSSStyleDeclaration) =>
  ['transform', 'perspective', 'filter', 'backdropFilter'].some((p) => st[p as 'transform'] !== '' && st[p as 'transform'] !== 'none') ||
  /transform|perspective|filter/u.test(st.willChange) ||
  /paint|layout|strict|content/u.test(st.contain);

export const fixedOrigin = (el: HTMLElement) => {
  for (let node = el.parentElement; node; node = node.parentElement) {
    if (!createsBlock(getComputedStyle(node))) continue;
    const r = node.getBoundingClientRect();
    return { x: r.left + node.clientLeft, y: r.top + node.clientTop };
  }
  return { x: 0, y: 0 };
};
```

## Hook Outline

1. Keep the panel in a signal and the placement in a signal.
2. In an effect: when open and both elements exist, measure once; register scroll (capture), resize and `ResizeObserver` handlers that schedule a measurement with `requestAnimationFrame`; clean up in `onCleanup`.
3. Measure: anchor box from `getBoundingClientRect`, panel size from `offsetWidth` and `offsetHeight` (width from the anchor when matching width), viewport from `documentElement.clientWidth` and `clientHeight`, then subtract `fixedOrigin(panel)` and round.
4. Style: `position: fixed`, `left`, `top`, `right: auto`, `bottom: auto`, `transform: none`, plus `width` when matching the anchor.
5. Expose `ref`, `style()` and `side()`; `side()` falls back to the preferred side before the first measurement.

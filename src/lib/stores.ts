import { cubicOut } from "svelte/easing";
import { tweened } from "svelte/motion";

export const scale = tweened(0., {
  duration: 1000,
  easing: cubicOut
});

export const mn = tweened([-2, -1], {
  duration: 1000,
  easing: cubicOut
});

export const mx = tweened([1, 1], {
  duration: 1000,
  easing: cubicOut
});

export const cx = tweened(0., {
  duration: 1000,
  easing: cubicOut
});

export const cy = tweened(0., {
  duration: 1000,
  easing: cubicOut
});

import { cubicOut } from "svelte/easing";
import { tweened } from "svelte/motion";
import { writable } from "svelte/store";

// TODO: enable
export const isTweenEnabled = writable(true);

export const scale = tweened(0., {
  duration: 400,
  easing: cubicOut
});

export const mn = tweened([-2, -1], {
  duration: 400,
  easing: cubicOut
});

export const mx = tweened([1, 1], {
  duration: 400,
  easing: cubicOut
});

export const cx = tweened(0., {
  duration: 400,
  easing: cubicOut
});

export const cy = tweened(0., {
  duration: 400,
  easing: cubicOut
});

export const exp = writable(2);

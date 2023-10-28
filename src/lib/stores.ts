import { cubicOut } from "svelte/easing";
import { spring, tweened } from "svelte/motion";
import { writable } from "svelte/store";

export const scale = tweened(0., {
  duration: 1000,
  easing: cubicOut
});
export const x = tweened(0., {
  duration: 1000,
  easing: cubicOut
});
export const y = tweened(0., {
  duration: 1000,
  easing: cubicOut
});

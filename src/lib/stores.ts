import { cubicOut } from "svelte/easing";
import { tweened } from "svelte/motion";

export const scale = tweened(0., {
  duration: 1000,
  easing: cubicOut
});
export const x = tweened(-1., {
  duration: 1000,
  easing: cubicOut
});
export const y = tweened(0., {
  duration: 1000,
  easing: cubicOut
});

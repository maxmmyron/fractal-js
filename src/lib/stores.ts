import { spring } from "svelte/motion";
import { writable } from "svelte/store";

export const scale = spring(0., {
  stiffness: 0.1,
  damping: 0.4,
});
export const x = spring(0., {
  stiffness: 0.1,
  damping: 0.4,
});
export const y = spring(0., {
  stiffness: 0.1,
  damping: 0.4,
});

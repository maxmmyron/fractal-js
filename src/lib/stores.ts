import { writable } from "svelte/store";

export const leftClamp = writable(-2.4);
export const rightClamp = writable(1.0);
export const scale = writable(1.0);
export const x = writable(0.0);
export const y = writable(0.0);


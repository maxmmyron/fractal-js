<script lang="ts">
  import type { Tweened } from "svelte/motion";
  import type { Writable } from "svelte/store";

  import { isTweenEnabled } from "$lib/stores";

  export let store: Writable<number> | Tweened<number>;
</script>

<label class="w-full grid grid-cols-6">
  <span class="font-bold col-start-1"><slot /></span>
  <input
    class="col-start-2 col-span-4"
    type="range"
    {...$$restProps}
    on:input={(e) => {
      store.set(e.currentTarget.valueAsNumber, {
        duration: $isTweenEnabled ? 500 : 0,
      });
    }}
  />
  <output class="col-start-6 text-right">{$store}</output>
</label>

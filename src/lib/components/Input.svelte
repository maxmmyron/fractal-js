<script lang="ts">
  import type { Writable } from "svelte/store";

  export let store: Writable<number>;
</script>

<label class="w-full grid grid-cols-6">
  <span class="font-bold col-start-1"><slot /></span>
  <input
    class="col-start-2 col-span-4"
    type="range"
    {...$$restProps}
    bind:value={$store}
  />
  <output class="col-start-6 text-right">{$store}</output>
</label>

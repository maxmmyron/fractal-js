<script lang="ts">
  import type { Writable } from "svelte/store";

  export let store: Writable<number>;
</script>

<label>
  <span style="font-weight: bold;"><slot /></span>
  <input type="range" {...$$restProps} bind:value={$store} />
  <output>{$store}</output>
</label>

<style>
  label {
    width: fit-content;
    display: flex;
    flex-direction: column;
    justify-content: center;
  }
</style>

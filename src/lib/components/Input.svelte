<script lang="ts">
  export let value: number;
</script>

<label class="w-full grid grid-cols-6">
  <span class="font-bold col-start-1"><slot /></span>
  <input
    class="col-start-2 col-span-4"
    type="range"
    {...$$restProps}
    bind:value
  />
  <output class="col-start-6 text-right">{value}</output>
</label>

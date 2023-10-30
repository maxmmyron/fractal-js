<script lang="ts">
  import { scale, mn, mx, cx, cy, exp } from "$lib/stores";
  import { Canvas } from "@threlte/core";
  import Scene from "$lib/Scene.svelte";
  import Input from "$lib/components/Input.svelte";
  import { onMount } from "svelte";

  let container: HTMLElement;

  let resolution: number[] = [0, 0];
  let viewType: App.Locals["View"] = "mandelbrot";

  let resetScene: (type: App.Locals["View"]) => void;

  onMount(() => (resolution = [container.clientWidth, container.clientHeight]));

  const reset = () => {
    scale.set(0, { duration: 0 });
    switch (viewType) {
      case "mandelbrot":
        mn.set([-2, (-3 * (resolution[1] / resolution[0])) / 2], {
          duration: 0,
        });
        mx.set([1, (3 * (resolution[1] / resolution[0])) / 2], { duration: 0 });
        resetScene(viewType);
        break;
      case "julia":
        mn.set([-2, (-4 * (resolution[1] / resolution[0])) / 2], {
          duration: 0,
        });
        mx.set([2, (4 * (resolution[1] / resolution[0])) / 2], { duration: 0 });
        cx.set(0.285, { duration: 0 });
        cy.set(0.01, { duration: 0 });
        resetScene(viewType);
        break;
      case "burningship":
        mn.set([-2, (-3.5 * (resolution[1] / resolution[0])) / 2 + 0.5], {
          duration: 0,
        });
        mx.set([1.5, (3.5 * (resolution[1] / resolution[0])) / 2 + 0.5], {
          duration: 0,
        });
        resetScene(viewType);
      default:
        throw new Error(`Unhandled view type "${viewType}"`);
    }
  };
</script>

<main class="flex h-screen">
  <section class="w-[480px] flex flex-col gap-8 p-4 border-r h-full">
    <header class="flex items-center justify-between gap-4">
      <h2 class="text-3xl font-bold">Controls</h2>
      <button on:click={reset}>Reset</button>
    </header>
    <fieldset class="border py-2 px-3">
      <legend>transform</legend>
      <Input bind:value={$scale} min={0} max={100} step={0.01}>Zoom</Input>
    </fieldset>
    <fieldset class="border py-2 px-3 space-y-3">
      <legend>render options</legend>
      <select bind:value={viewType} class="py-1 px-2" on:change={reset}>
        <option value="mandelbrot" selected>Mandelbrot Set</option>
        <option value="julia">Julia Set</option>
        <option value="burningship">Burning Ship</option>
      </select>
      {#if viewType === "mandelbrot"}
        <Input bind:value={$exp} min={2} max={10} step={1}>Exponent</Input>
      {/if}
      {#if viewType === "julia"}
        <Input bind:value={$cx} min={-2} max={2} step={0.01}>
          C<sub>x</sub>
        </Input>
        <Input bind:value={$cy} min={-2} max={2} step={0.01}>
          C<sub>y</sub>
        </Input>
      {/if}
      <br />
    </fieldset>
  </section>
  <section class="flex-1" bind:this={container}>
    <Canvas>
      <Scene {resolution} {viewType} bind:reset={resetScene} />
    </Canvas>
  </section>
</main>

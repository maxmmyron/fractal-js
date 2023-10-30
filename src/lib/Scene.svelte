<script lang="ts">
  import { scale, mn, mx, cx, cy, exp } from "$lib/stores";
  import { norm, getViewValue } from "$lib/util";
  import vertexShader from "$lib/shaders/vertex.glsl?raw";
  import fragmentShader from "$lib/shaders/fragment.glsl?raw";
  import { T } from "@threlte/core";
  import { interactivity } from "@threlte/extras";
  import { onMount } from "svelte";

  export let resolution: number[];
  export let viewType: App.Locals["View"] = "mandelbrot";

  export const reset = (type: App.Locals["View"]) => {
    switch (type) {
      case "mandelbrot":
        (xmin = -2), (ymin = (-3 * (resolution[1] / resolution[0])) / 2);
        (xmax = 1), (ymax = (3 * (resolution[1] / resolution[0])) / 2);
        break;
      case "julia":
        (xmin = -2), (ymin = (-4 * (resolution[1] / resolution[0])) / 2);
        (xmax = 2), (ymax = (4 * (resolution[1] / resolution[0])) / 2);
        break;
      case "burningship":
        (xmin = -2),
          (ymin = (-3.5 * (resolution[1] / resolution[0])) / 2 + 0.5);
        (xmax = 1.5),
          (ymax = (3.5 * (resolution[1] / resolution[0])) / 2 + 0.5);
        break;
      default:
        throw new Error(`Unhandled view type "${type}"`);
    }
  };

  // i don't really understand why 7.68 fits the plane to the screen ¯\_(ツ)_/¯
  const planeScaling = 7.68;
  // define plane width and height (i.e. coordinate system of zoom point)
  const planeW = (resolution[0] / resolution[1]) * planeScaling;
  const planeH = planeScaling;

  // initial plotting values
  let xmin = -2;
  let xmax = 1;

  let ymin = (-(xmax - xmin) * (planeH / planeW)) / 2;
  let ymax = ((xmax - xmin) * (planeH / planeW)) / 2;

  onMount(() => {
    // set initial plotting values
    mn.set([xmin, ymin], { duration: 0 });
    mx.set([xmax, ymax], { duration: 0 });
  });

  interactivity();

  const zoom = (
    e: unknown & { point: { x: number; y: number; z: number } }
  ) => {
    // get the current mouse position
    const { point } = e;

    // noramlize mouse position to the plotting plane
    const normedCenterX = norm(point.x, -planeW / 2, planeW / 2, xmin, xmax);
    const normedCenterY = norm(point.y, -planeH / 2, planeH / 2, ymin, ymax);

    // (normedX, normedY) represents our new center point.
    // our xmin, xmax, ymin, ymax are the bounds of the plotting plane.
    // these are calculated by scaling in the current plot width and height by 2.

    // calculate the new width and height of the plotting plane
    const width = (xmax - xmin) / 2;
    const height = (ymax - ymin) / 2;

    // calculate the new bounds of the plotting plane
    xmin = normedCenterX - width / 2;
    xmax = normedCenterX + width / 2;

    ymin = normedCenterY - height / 2;
    ymax = normedCenterY + height / 2;

    // update uniforms and scale
    mn.set([xmin, ymin]);
    mx.set([xmax, ymax]);
    scale.set($scale + 1);
  };
</script>

<T.Mesh on:click={zoom}>
  <T.PlaneGeometry
    args={[(resolution[0] / resolution[1]) * planeScaling, planeScaling]}
  />
  <T.ShaderMaterial
    {vertexShader}
    {fragmentShader}
    uniforms={{
      resolution: { value: resolution },
      scale: { value: 0.0 },
      mn: { value: [-2, (-3 * (resolution[1] / resolution[0])) / 2] },
      mx: { value: [1, (3 * (resolution[1] / resolution[0])) / 2] },
      juliaC: { value: [0.0, 0.0] },
      view: { value: 0 },
      exp: { value: 2 },
    }}
    uniforms.scale.value={$scale}
    uniforms.mn.value={$mn}
    uniforms.mx.value={$mx}
    uniforms.juliaC.value={[$cx, $cy]}
    uniforms.view.value={getViewValue(viewType)}
    uniforms.exp.value={$exp}
  />
</T.Mesh>

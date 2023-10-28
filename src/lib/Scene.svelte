<script lang="ts">
  import { scale, x, y } from "$lib/stores";
  import vertexShader from "$lib/shaders/vertex.glsl?raw";
  import fragmentShader from "$lib/shaders/fragment.glsl?raw";
  import { T } from "@threlte/core";
  import { interactivity } from "@threlte/extras";

  // i don't really understand why 7.68 fits the plane to the screen ¯\_(ツ)_/¯
  let planeScaling = 7.68;

  let xmin = -2.4;
  let xmax = 1.0;

  let yRange = (xmax - xmin) * (1 / 1.6);

  let ymin = -yRange / 2;
  let ymax = yRange / 2;

  const normalize = (
    value: number,
    localmin: number,
    localmax: number,
    min: number,
    max: number
  ) => {
    let norm = (value - localmin) / (localmax - localmin);
    return norm * (max - min) + min;
  };

  interactivity();
  const zoom = (e) => {
    // given scale, x, and y, calculate the new scale, x, and y.
    // x and y is the current center of the screen.
    // scale is the current zoom level, expressed at pow(1.5, scale).

    // get the current mouse position
    const { point } = e;

    let normedX = normalize(
      point.x,
      (-1.6 * planeScaling) / 2,
      (1.6 * planeScaling) / 2,
      xmin,
      xmax
    );
    let normedY = normalize(
      point.y,
      -planeScaling / 2,
      planeScaling / 2,
      ymin,
      ymax
    );

    const width = 3.4 / Math.pow(1.5, $scale);
    const height = width / 2;

    xmin = normedX - width / 2;
    xmax = normedX + width / 2;

    ymin = normedY - height / 2;
    ymax = normedY + height / 2;

    // set the new values
    scale.set($scale + 1);
    x.set(normedX);
    y.set(normedY);
  };
</script>

<T.Mesh on:click={zoom}>
  <T.PlaneGeometry args={[1.6 * planeScaling, planeScaling]} />
  <T.ShaderMaterial
    {vertexShader}
    {fragmentShader}
    uniforms={{
      resolution: { value: [window.innerWidth, window.innerHeight] },
      scale: { value: 1.0 },
      position: { value: [0, 0] },
    }}
    uniforms.scale.value={$scale}
    uniforms.position.value={[$x, $y]}
  />
</T.Mesh>

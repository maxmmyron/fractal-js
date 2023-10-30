export const getViewValue = (view: App.Locals["View"]) => {
  switch (view) {
    case "mandelbrot":
      return 0;
    case "julia":
      return 1;
  }
};

/**
 * Normalize a value within an arbitrary range to a new range
 * @param value Number to be normalized
 * @param localmin Local minimum
 * @param localmax Local maximum
 * @param min minimum to be normalized to
 * @param max maximum to be normalized to
 * @returns
 */
export const norm = (
    value: number,
    localmin: number,
    localmax: number,
    min: number,
    max: number
  ) => {
    let norm = (value - localmin) / (localmax - localmin);
    return norm * (max - min) + min;
  };

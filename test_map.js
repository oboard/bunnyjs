
try {
  const arr = [1, 2, 3];
  const mapped = arr.map(x => x * 2);
  console.log(mapped.join(",")); // Should be 2,4,6
} catch (e) {
  console.log("Error in map basic:", e);
}

try {
  const arr = [1, 2, 3];
  arr.map("not a function");
} catch (e) {
  console.log("Caught expected error:", e);
}

try {
  const arr = new Array(3);
  arr[0] = 1;
  arr[2] = 3;
  const mapped = arr.map(x => x * 2);
  console.log("Sparse length:", mapped.length);
  console.log("Sparse 0:", mapped[0]);
  console.log("Sparse 1:", mapped[1]); // Should be undefined/empty
  console.log("Sparse 2:", mapped[2]);
} catch (e) {
  console.log("Error in sparse:", e);
}

function getSplitPoint(n) {
  if (n < 1) {
    throw Error("Trying to split tree with length < 1");
  }

  let mid = 2 ** Math.floor(Math.log2(n));
  if (mid === n) {
    mid /= 2;
  }
  console.log("mid", mid);
  return mid;
  
}

const mid = getSplitPoint(1);

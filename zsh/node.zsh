npm() {
  echo "use yarn or $(/usr/bin/which npm)" >&2;
  return 1;
}

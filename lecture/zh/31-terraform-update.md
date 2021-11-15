terraform version
0.12.31

terraform 0.12upgrade

for m in `ls modules`; do
  terraform 0.12upgrade -yes modules/$m
done

terraform version
0.13.7

terraform 0.13upgrade

for m in `ls modules`; do
  terraform 0.13upgrade -yes modules/$m
done

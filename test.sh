PORT=8080 # Set to same as the var.external_port
for i in {1..10}; do
  curl http://localhost:${PORT};
  sleep 5;
  echo ""
done

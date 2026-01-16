# Lesson 1


## Backend


1. Deploy `backend` files to your VM using `scp` (under `/home/admin/app`)
```
cd <path-to-project>/backend
scp -r [-i <path-to-private-key>] core *toml *lock *md admin@<your-vm-ip-address>:/home/admin/app
```
2. Source env vars available at `/home/admin/app/env.sh`
3. `cd` into `/home/admin/app/` folder 
4. install project dependencies
```
uv sync
```
5. init app DB
```
cd core
uv run python manage.py migrate
uv run python manage.py createsuperuser
```
6. Run app on port 5000
```
uv run python manage.py runserver 0.0.0.0:5000
```
7. Visit `<your.vm.dns>:5000/admin/` (do not forget the trailing slash)



## Frontend

1. Install NGINX
```bash
sudo apt update
sudo apt install nginx -y
```

2. Check NGINX is running
```bash
sudo systemctl status nginx
```
Visit `http://<your-vm-ip-address>` in your browser - you should see the default NGINX welcome page.

3. Build the frontend locally (on your machine, not the VM)
```bash
cd <path-to-project>/frontend
npm install
npm run build
```
This creates a `dist/` folder with the production-ready static files.

4. Deploy the built files to your VM
```bash
scp -r [-i <path-to-private-key>] dist/* admin@<your-vm-ip-address>:/tmp/frontend/
```

5. On the VM, move files to the NGINX web root
```bash
sudo rm -rf /var/www/html/*
sudo mv /tmp/frontend/* /var/www/html/
```

6. Visit `http://<your-vm-ip-address>` to see your frontend application
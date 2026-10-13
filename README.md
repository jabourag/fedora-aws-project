# Hardened Fedora Golden Image (AWS)


## Project Purpose
This repository serves as the source of truth for Fedora Lane's secure cloud base image. It addresses the challenge of providing a standardized, CIS-hardened OS environment while maintaining strict security controls (SELinux in `Enforcing` mode, restricted SSH access) and providing an auditable, GUI-based management interface for administrators.

## Repository Contents
* `scripts/setup_environment.sh`: Automated deployment script to install Cockpit, Session Recording, Podman, and configure SSH boundaries.
* `.pre-commit-config.yaml`: Code hygiene hooks enforcing YAML standards and preventing credential leaks.

## Setup and Deployment Instructions

### 1. Pre-requisites
* An active AWS EC2 instance running a base Fedora/RHEL image.
* Local SSH key access to the instance.

### 2. Deploying the Environment
Upload and execute the setup script on the target server:
`scp -i /path/to/key.pem scripts/setup_environment.sh ec2-user@<AWS_INSTANCE_IP>:/home/ec2-user/`
`ssh -i /path/to/key.pem ec2-user@<AWS_INSTANCE_IP>`
`sudo ./setup_environment.sh`

### 3. Running the Solution
To securely access the hardened Web Console without exposing port 9090 to the internet, use an SSH tunnel over the restricted management port (2222):
`ssh -i /path/to/key.pem -p 2222 -L 9090:localhost:9090 ec2-user@<AWS_INSTANCE_IP>`
Once connected, open a local web browser and navigate to `https://localhost:9090`.




### Creating the Matrix Dashboard 
cat << 'EOF' > ~/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fedora Lane | Matrix Hardened Node Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Courier New', Courier, monospace; }
        body { background-color: #000; color: #0f0; overflow-x: hidden; min-height: 100vh; display: flex; flex-direction: column; align-items: center; }
        canvas { position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 1; opacity: 0.25; pointer-events: none; }
        .container { position: relative; z-index: 2; width: 90%; max-width: 1200px; margin: 20px auto; padding: 20px; background: rgba(0, 10, 0, 0.85); border: 1px solid #0f0; box-shadow: 0 0 20px rgba(0, 255, 0, 0.3); border-radius: 5px; }
        header { text-align: center; border-bottom: 1px solid #0f0; padding-bottom: 15px; margin-bottom: 20px; }
        h1 { font-size: 2rem; text-shadow: 0 0 10px #0f0; letter-spacing: 2px; }
        .status-badge { display: inline-block; background: #0f0; color: #000; padding: 5px 10px; font-weight: bold; margin-top: 10px; border-radius: 3px; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 15px; margin-bottom: 20px; }
        .card { background: rgba(0, 20, 0, 0.6); border: 1px solid #005500; padding: 15px; border-radius: 4px; transition: border 0.3s; }
        .card:hover { border-color: #0f0; box-shadow: 0 0 10px rgba(0,255,0,0.2); }
        .card h3 { color: #0f0; border-bottom: 1px solid #005500; padding-bottom: 5px; margin-bottom: 10px; }
        .card p { font-size: 0.9rem; color: #8f8; line-height: 1.4; }
        .card .val { color: #fff; font-weight: bold; }
        .terminal { background: #020202; border: 1px solid #0f0; padding: 15px; border-radius: 4px; height: 250px; overflow-y: auto; font-size: 0.85rem; color: #0f0; margin-top: 10px; }
        .line { margin-bottom: 5px; }
        .prompt { color: #0a0; }
    </style>
</head>
<body>
    <canvas id="matrix"></canvas>
    <div class="container">
        <header>
            <h1>FEDORA LANE // GOLDEN IMAGE NODE</h1>
            <div class="status-badge">STATUS: HARDENED & ENFORCING</div>
        </header>

        <div class="grid">
            <div class="card">
                <h3>Base Infrastructure</h3>
                <p>OS: <span class="val">Red Hat Enterprise Linux 9</span></p>
                <p>Environment: <span class="val">AWS EC2 Instance</span></p>
                <p>SSH Port: <span class="val">2222 (Isolated)</span></p>
            </div>
            <div class="card">
                <h3>Security & Compliance</h3>
                <p>SELinux Mode: <span class="val">Enforcing</span></p>
                <p>/tmp Execution: <span class="val">noexec (Mounted)</span></p>
                <p>Root/Pass SSH: <span class="val">Disabled</span></p>
            </div>
            <div class="card">
                <h3>Audit & Container Services</h3>
                <p>Session Logging: <span class="val">tlog Active</span></p>
                <p>Web Server: <span class="val">Podman httpd</span></p>
                <p>Service Port: <span class="val">35443 (Custom)</span></p>
            </div>
        </div>

        <h3>System Audit Stream</h3>
        <div class="terminal" id="terminal">
            <div class="line"><span class="prompt">systemd@fedora-lane:~$</span> Initializing security checks...</div>
            <div class="line"><span class="prompt">systemd@fedora-lane:~$</span> SELinux status: Enforcing [PASS]</div>
            <div class="line"><span class="prompt">systemd@fedora-lane:~$</span> SSH Service binding: Port 2222 [PASS]</div>
            <div class="line"><span class="prompt">systemd@fedora-lane:~$</span> Storage Isolation: /var/log, /home, /tmp mounted [PASS]</div>
            <div class="line"><span class="prompt">systemd@fedora-lane:~$</span> Audit daemon tlog-rec-session hooked [PASS]</div>
            <div class="line"><span class="prompt">systemd@fedora-lane:~$</span> httpd container running on port 35443 [PASS]</div>
        </div>
    </div>

    <script>
        const canvas = document.getElementById('matrix');
        const ctx = canvas.getContext('2d');
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
        const katakana = 'アァカサタナハマヤャラワガザダバパイィキシチニヒミリヰギジヂビピウゥクスツヌフムユュルグズブヅプエェケセテネヘメレヱゲゼデベペオォコソトノホモヨョロヲゴゾドボポヴッン';
        const latin = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        const alphabet = katakana + latin;
        const fontSize = 16;
        const columns = canvas.width / fontSize;
        const rainDrops = Array.from({ length: columns }).fill(1);

        function draw() {
            ctx.fillStyle = 'rgba(0, 0, 0, 0.05)';
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            ctx.fillStyle = '#0F0';
            ctx.font = fontSize + 'px monospace';
            for (let i = 0; i < rainDrops.length; i++) {
                const text = alphabet.charAt(Math.floor(Math.random() * alphabet.length));
                ctx.fillText(text, i * fontSize, rainDrops[i] * fontSize);
                if (rainDrops[i] * fontSize > canvas.height && Math.random() > 0.975) {
                    rainDrops[i] = 0;
                }
                rainDrops[i]++;
            }
        }
        setInterval(draw, 30);
    </script>
</body>
</html>
EOF

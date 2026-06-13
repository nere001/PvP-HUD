import base64

html_content = """<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PvP HUD for ESX (FiveM)</title>
    <style>
        *, *::before, *::after {
            box-sizing: border-box;
        }
        @page {
            size: A4;
            margin: 18mm 15mm;
            background-color: #0d1117;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji";
            font-size: 11pt;
            line-height: 1.6;
            color: #c9d1d9;
            background-color: #0d1117;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 100%;
        }
        .header {
            border-bottom: 1px solid #21262d;
            padding-bottom: 15px;
            margin-bottom: 25px;
        }
        h1 {
            font-size: 22pt;
            color: #58a6ff;
            margin: 0 0 10px 0;
            font-weight: 600;
        }
        .badge-container {
            margin-bottom: 10px;
        }
        .badge {
            display: inline-block;
            padding: 4px 10px;
            font-size: 9pt;
            font-weight: 600;
            line-height: 1;
            border-radius: 6px;
            margin-right: 8px;
        }
        .badge-framework {
            background-color: #388bfd;
            color: #ffffff;
        }
        .badge-requirement {
            background-color: #f0883e;
            color: #ffffff;
        }
        h2 {
            font-size: 14pt;
            color: #e6edf3;
            border-bottom: 1px solid #21262d;
            padding-bottom: 6px;
            margin-top: 25px;
            margin-bottom: 12px;
            font-weight: 600;
        }
        p {
            margin-top: 0;
            margin-bottom: 12px;
        }
        ul {
            margin-top: 0;
            margin-bottom: 16px;
            padding-left: 20px;
        }
        li {
            margin-bottom: 6px;
        }
        .code-block {
            background-color: #161b22;
            border: 1px solid #30363d;
            border-radius: 6px;
            padding: 12px;
            font-family: ui-monospace, SFMono-Regular, SF Mono, Menlo, Consolas, Liberation Mono, monospace;
            font-size: 10pt;
            color: #e6edf3;
            margin-bottom: 16px;
        }
        .command {
            color: #ff7b72;
            font-weight: bold;
        }
        .description {
            color: #8b949e;
        }
        .feature-box {
            background-color: #161b22;
            border-left: 4px solid #58a6ff;
            padding: 12px;
            border-radius: 0 6px 6px 0;
            margin-bottom: 16px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>PvP HUD for ESX (FiveM)</h1>
            <div class="badge-container">
                <span class="badge badge-framework">Framework: ESX</span>
                <span class="badge badge-requirement">Requires: Ox_Lib</span>
            </div>
            <p style="color: #8b949e; margin-top: 8px; font-size: 11pt;">Highly optimized, interactive, and customizable player head-up display tailored for PvP environments in FiveM.</p>
        </div>

        <h2>Description</h2>
        <p>A modern and clean PvP-focused HUD designed specifically for the ESX framework. This resource offers seamless UI manipulation directly in-game, giving players absolute control over their layout, optimizing screen real estate, and ensuring peak visibility during combat situations.</p>

        <h2>Requirements</h2>
        <ul>
            <li><strong>FiveM Artifacts:</strong> Latest recommended version.</li>
            <li><strong>Framework:</strong> ESX Legacy / ESX (Any modern version).</li>
            <li><strong>Dependency:</strong> <a href="https://github.com/overextended/ox_lib" style="color: #58a6ff; text-decoration: none;">ox_lib</a> (Used for user interface elements, optimized performance, and settings storage).</li>
        </ul>

        <h2>Commands</h2>
        <p>Players can use the following command to completely customize their interface experience:</p>
        <div class="code-block">
            <span class="command">/hud</span> <span class="description">- Opens the configuration menu to adjust, move, resize, or hide HUD elements.</span>
        </div>

        <h2>Key Features</h2>
        <div class="feature-box">
            <ul style="margin-bottom: 0;">
                <li><strong>Real-time Customization:</strong> Adjust size scales dynamically.</li>
                <li><strong>Drag & Drop Layout:</strong> Move elements anywhere across the viewport.</li>
                <li><strong>Visibility Toggle:</strong> Hide specific or all components when not needed.</li>
                <li><strong>Ox_Lib Backend:</strong> Utilizes lightweight and reliable libraries to guarantee 0.00ms idle usage.</li>
            </ul>
        </div>
    </div>
</body>
</html>
"""

# Save the HTML file
with open("README.html", "w", encoding="utf-8") as f:
    f.write(html_content)

print("HTML template generated successfully.")

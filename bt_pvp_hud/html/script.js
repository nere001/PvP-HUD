let currentHealth = 100;
let currentArmor = 0;
let isMovingMode = false;
let isDragging = false;
let offsetX = 0, offsetY = 0;

const hudContainer = document.getElementById('hudContainer');
const healthValue = document.getElementById('healthValue');
const armorValue = document.getElementById('armorValue');

function updateHealthValue(value) {
    const percent = Math.min(100, Math.max(0, value));
    healthValue.innerText = Math.floor(percent);
    
    if (percent < 51) {
        hudContainer.classList.add('low-health');
    } else {
        hudContainer.classList.remove('low-health');
    }
}

function updateArmorValue(value) {
    const percent = Math.min(100, Math.max(0, value));
    armorValue.innerText = Math.floor(percent);
}

function centerHUD() {
    hudContainer.style.left = '50%';
    hudContainer.style.transform = 'translateX(-50%)';
    hudContainer.style.bottom = '30px';
    hudContainer.style.top = 'auto';
    hudContainer.style.right = 'auto';
}

window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'updateHUD') {
        if (data.health !== undefined) {
            currentHealth = data.health;
            updateHealthValue(currentHealth);
        }
        if (data.armor !== undefined) {
            currentArmor = data.armor;
            updateArmorValue(currentArmor);
        }
    }
    else if (data.action === 'toggleHUD') {
        hudContainer.style.display = data.visible ? 'flex' : 'none';
    }
    else if (data.action === 'show') {
        hudContainer.style.display = 'flex';
        fetch('https://bt_pvp_hud/getPosition', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        }).then(function(resp) { 
            return resp.json(); 
        }).then(function(pos) {
            if (pos && pos.x !== undefined && pos.x !== null) {
                hudContainer.style.left = pos.x + 'px';
                hudContainer.style.transform = 'none';
                hudContainer.style.bottom = pos.y + 'px';
                hudContainer.style.top = 'auto';
                hudContainer.style.right = 'auto';
            } else {
                centerHUD();
            }
        }).catch(function(err) {
            console.log('Chyba nacitani pozice:', err);
            centerHUD();
        });
    }
    else if (data.action === 'enterMoveMode') {
        isMovingMode = true;
        hudContainer.classList.add('moving');
        hudContainer.style.cursor = 'move';
    }
    else if (data.action === 'resetPosition') {
        if (data.x === null) {
            centerHUD();
        } else {
            hudContainer.style.left = data.x + 'px';
            hudContainer.style.transform = 'none';
            hudContainer.style.bottom = data.y + 'px';
        }
    }
    else if (data.action === 'updateScale') {
        if (data.scale) {
            var scalePercent = data.scale / 100;
            if (hudContainer.style.left === '50%' || (!hudContainer.style.left || hudContainer.style.left === '')) {
                hudContainer.style.transform = 'translateX(-50%) scale(' + scalePercent + ')';
            } else {
                hudContainer.style.transform = 'scale(' + scalePercent + ')';
            }
        }
    }
    else if (data.action === 'resetAll') {
        if (data.scale) {
            var scalePercent = data.scale / 100;
            centerHUD();
            hudContainer.style.transform = 'translateX(-50%) scale(' + scalePercent + ')';
        }
        if (data.visible !== undefined) {
            hudContainer.style.display = data.visible ? 'flex' : 'none';
        }
    }
    else if (data.action === 'setExactPosition') {
        if (data.x !== null && data.x !== undefined) {
            hudContainer.style.left = data.x + 'px';
            hudContainer.style.transform = 'none';
            hudContainer.style.bottom = data.y + 'px';
            hudContainer.style.top = 'auto';
            hudContainer.style.right = 'auto';
        }
    }
    else if (data.action === 'saveScaleToStorage') {
        if (data.scale) {
            fetch('https://bt_pvp_hud/saveScaleToServer', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ scale: data.scale })
            });
        }
    }
});

hudContainer.addEventListener('mousedown', function(e) {
    if (!isMovingMode || e.button !== 0) return;
    
    e.preventDefault();
    isDragging = true;
    var rect = hudContainer.getBoundingClientRect();
    offsetX = e.clientX - rect.left;
    offsetY = e.clientY - rect.top;
    
    document.addEventListener('mousemove', onMouseMove);
    document.addEventListener('mouseup', onMouseUp);
});

function onMouseMove(e) {
    if (!isDragging) return;
    
    var newLeft = e.clientX - offsetX;
    var newTop = e.clientY - offsetY;
    
    var maxLeft = window.innerWidth - hudContainer.offsetWidth;
    var maxTop = window.innerHeight - hudContainer.offsetHeight;
    newLeft = Math.min(maxLeft, Math.max(0, newLeft));
    newTop = Math.min(maxTop, Math.max(0, newTop));
    
    hudContainer.style.left = newLeft + 'px';
    hudContainer.style.top = newTop + 'px';
    hudContainer.style.transform = 'none';
    hudContainer.style.bottom = 'auto';
    hudContainer.style.right = 'auto';
}

function onMouseUp() {
    isDragging = false;
    document.removeEventListener('mousemove', onMouseMove);
    document.removeEventListener('mouseup', onMouseUp);
}

document.addEventListener('contextmenu', function(e) {
    if (!isMovingMode) return;
    e.preventDefault();
    
    isDragging = false;
    isMovingMode = false;
    
    hudContainer.classList.remove('moving');
    hudContainer.style.cursor = 'default';
    
    document.removeEventListener('mousemove', onMouseMove);
    document.removeEventListener('mouseup', onMouseUp);
    
    var left = parseInt(hudContainer.style.left) || 0;
    var top = parseInt(hudContainer.style.top) || 0;
    var bottom = window.innerHeight - top - hudContainer.offsetHeight;
    
    fetch('https://bt_pvp_hud/savePosition', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ x: left, y: bottom })
    });
    
    fetch('https://bt_pvp_hud/disableFocus', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
});

fetch('https://bt_pvp_hud/getScale', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({})
}).then(function(resp) {
    return resp.json();
}).then(function(scale) {
    if (scale && scale !== 100) {
        var scalePercent = scale / 100;
        if (hudContainer.style.left === '50%' || (!hudContainer.style.left || hudContainer.style.left === '')) {
            hudContainer.style.transform = 'translateX(-50%) scale(' + scalePercent + ')';
        } else {
            hudContainer.style.transform = 'scale(' + scalePercent + ')';
        }
    }
}).catch(function(err) {
    console.log('Chyba nacitani scale:', err);
});

hudContainer.style.display = 'none';
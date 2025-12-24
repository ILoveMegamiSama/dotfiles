#!/bin/bash

# --- CẤU HÌNH ĐỘ TRONG SUỐT MẶC ĐỊNH ---
# Khi tắt chế độ "Đặc", cửa sổ sẽ về độ trong suốt này
DEFAULT_ALPHA=0.8
# ---------------------------------------

addr=$(hyprctl activewindow -j | jq -r '.address')

if [ "$addr" == "null" ] || [ -z "$addr" ]; then
    notify-send "Lỗi" "Không tìm thấy cửa sổ!"
    exit
fi

lock_file="/tmp/hypr_opaque_${addr}"

if [ -f "$lock_file" ]; then
    # --- CHUYỂN VỀ TRONG SUỐT (Mặc định) ---
    # Ép độ trong suốt về lại mức 0.8 (hoặc số bạn chỉnh)
    hyprctl dispatch setprop address:$addr alphaoverride $DEFAULT_ALPHA
    
    # Xóa file lock
    rm "$lock_file"
    notify-send "Hyprland" "Đã bật Trong suốt ($DEFAULT_ALPHA)"
else
    # --- CHUYỂN SANG ĐẶC (Rõ nét) ---
    # Ép độ trong suốt lên 1.0 (Không nhìn xuyên qua được)
    hyprctl dispatch setprop address:$addr alphaoverride 1.0
    
    # Tạo file lock
    touch "$lock_file"
    notify-send "Hyprland" "Đã bật chế độ ĐẶC (1.0)"
fi

#!/usr/bin/env python3

import dbus
from subprocess import getoutput as run

def getStatus():
    try: 
        return run("nmcli general status").split('\n')[1].split()[0].lower()
    except: return None

def getStren():
    try:
        NM, DBUS = "org.freedesktop.NetworkManager", "org.freedesktop.DBus.Properties"
        bus = dbus.SystemBus()
        nm = bus.get_object(NM, f"/{NM.replace('.', '/')}")
        
        conn_type = nm.Get(NM, "PrimaryConnectionType", dbus_interface=DBUS)
        if conn_type != "802-11-wireless": return None
            
        conn = bus.get_object(NM, 
            nm.Get(NM, "PrimaryConnection", dbus_interface=DBUS)
        )
        ap = bus.get_object(NM, conn.Get(
            f"{NM}.Connection.Active", "SpecificObject", dbus_interface=DBUS)
        )
        return int(ap.Get(f"{NM}.AccessPoint", "Strength", dbus_interface=DBUS) or 0)
    except Exception: return None

def report():
    status = getStatus()

    if status in ("connecting", "disconnected"): return "󰣽 "
    if status == "connected":
        stren = getStren()

        if stren is None:        return "󰈀 "
        elif stren == 0:         return "󰣾 "
        elif 0 < stren <= 25:    return "󰣴 "
        elif 25 < stren <= 50:   return "󰣶 "
        elif 50 < stren <= 75:   return "󰣸 "
        elif 75 < stren <= 100:  return "󰣺 "
        
    return " "

print(report(), end='')

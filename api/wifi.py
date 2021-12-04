import subprocess
import shutil
import utils
from pathlib import Path

@utils.to_list
def get_available_networks(interface):
    data, _ = subprocess.Popen(['iwlist', interface, 'scan'], stdout=subprocess.PIPE).communicate()
    data = data.decode('utf-8').strip().split('\n')
    for line in data:
        if 'ESSID' in line:
            yield line.strip().split(':')[1][1:-1]

def try_to_connect(ssid, password):
    with open('./configs/wpa_supplicant.conf') as f:
        data = f.read()

    data = data.replace('#SSID#', ssid)
    data = data.replace('#PASSWORD#', password)
    
    with open('./tmp/wpa_supplicant.conf', 'w') as f:
        f.write(data)

    print(data)

    shutil.move('./tmp/wpa_supplicant.conf', '/etc/wpa_supplicant/wpa_supplicant.conf')
    return_code = subprocess.call(['systemctl', 'restart', 'wpa_supplicant'])
    print(return_code)
    
    return return_code == 0


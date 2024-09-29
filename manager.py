#!/usr/bin/python 


import sys
import json
import subprocess

def exec(cmd):
    try:
        if cmd:
            subprocess.run(cmd, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error occurred: {e.stderr}")

with open('manager_file.json','r') as file:
        data = json.load(file)

def getFile(key):
    print(data[key])



def modifyJson(key,value):
    data[key] = value
    with open('manager_file.json','w') as file:
        json.dump(data,file,indent=4)
    

def strictMode():
    exec("fwsnort --ipt-flush >/dev/null")
    for rule_key in data:
        if( "rules" in rule_key ):
            cmd = f"fwsnort --snort-rfile={data[rule_key]} >/dev/null"
            exec(cmd)
            cmd = '/var/lib/fwsnort/fwsnort.sh >/dev/null'
            exec(cmd)
            print(f"[+] {rule_key}...")
    
if __name__=="__main__":

    if(len(sys.argv)>1):
        if(sys.argv[1]=="GET"):
            getFile(sys.argv[2])
        elif(sys.argv[1]=="MOD"):
            modifyJson(sys.argv[2],sys.argv[3])
        elif(sys.argv[1]=="STR"):
            strictMode()    
    
    

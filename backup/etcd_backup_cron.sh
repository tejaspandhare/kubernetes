#!/usr/bin/bash

LOGFILE="/root/backups/logs/k8s_backup.log"

# ETCD Snapshot
if etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key snapshot save /root/backups/k8scluster/etcd/"etcd.backup.$(date +'%Y-%d%B').db" >> "$LOGFILE" 2>&1; then
    echo "ETCD snapshot created successfully." >> "$LOGFILE"
else
    echo "ETCD snapshot failed!" >> "$LOGFILE"
fi

# Backup of /var/lib/etcd
if tar cf /root/backups/k8scluster/etcd/"varlibetcd.bkp.$(date +'%Y-%d%B').tar" /var/lib/etcd >> "$LOGFILE" 2>&1; then
    echo "varlibetcd backup created successfully." >> "$LOGFILE"
else
    echo "varlibetcd backup failed!" >> "$LOGFILE"
fi

# Backup of Kubernetes Manifests
if tar --exclude='tmp' -cf /root/backups/k8scluster/etc_k8s/"etc_k8s_manifests_yaml.backup.$(date +'%Y-%d%B').tar" -C /etc/kubernetes . >> "$LOGFILE" 2>&1; then
    echo "Kubernetes manifests backup created successfully." >> "$LOGFILE"
else
    echo "Kubernetes manifests backup failed!" >> "$LOGFILE"
fi

# Backup of Containerd Configuration
if tar cf /root/backups/k8scluster/containerd/"containerdbackup.$(date +'%Y-%d%B').tar" /etc/containerd >> "$LOGFILE" 2>&1; then
    echo "Containerd backup created successfully." >> "$LOGFILE"
else
    echo "Containerd backup failed!" >> "$LOGFILE"
fi

# Cleanup of Old Backups
deleted_files=$(find /root/backups/k8scluster/ -type f -mtime +6)

if [ -n "$deleted_files" ]; then
    echo "$deleted_files" >> "$LOGFILE"
    echo "$deleted_files" | xargs -d '\n' -I {} echo "Deleted: {}" >> "$LOGFILE"
    find /root/backups/k8scluster/ -type f -mtime +6 -delete >> "$LOGFILE" 2>&1
    echo "Old backups deleted." >> "$LOGFILE"
else
    echo "No files matched to delete." >> "$LOGFILE"
fi

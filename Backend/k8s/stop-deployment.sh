kubectl delete all --all

# No vamos a eliminar el volumen porque queremos mantener los datos de la base de datos, pero
# por si hay que reiniciar, aquí está el comando:
#kubectl delete pvc oracle-pvc
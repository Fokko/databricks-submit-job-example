from pyspark.sql import SparkSession
import random

spark = SparkSession.builder \
    .master("local") \
    .appName("Compute PI") \
    .getOrCreate()

sc = spark.sparkContext

def inside(p):
    x, y = random.random(), random.random()
    return x * x + y * y < 1

NUM_SAMPLES = 100000

count = sc.parallelize(range(0, NUM_SAMPLES)) \
    .filter(inside).count()
print("Pi is roughly %f" % (4.0 * count / NUM_SAMPLES))

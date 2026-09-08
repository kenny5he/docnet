
HADOOP_CMD="/usr/local/src/hadoop-1.2.1/bin/hadoop"
STREAM_JAR_PATH="/usr/local/src/hadoop-1.2.1/contrib/streaming/hadoop-streaming-1.2.1.jar"

INPUT_PATH="/output_cachearchive_broadcast"
OUTPUT_PATH="/output_cat"

#$HADOOP_CMD fs -rmr -skipTrash $OUTPUT_PATH

# Step 1.
$HADOOP_CMD jar $STREAM_JAR_PATH \
    -input $INPUT_PATH\
    -output $OUTPUT_PATH\
    -mapper "cat" \
    -jobconf "mapred.reduce.tasks=0"


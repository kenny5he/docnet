set -e -x

HADOOP_CMD="/usr/local/src/hadoop-1.2.1/bin/hadoop"
STREAM_JAR_PATH="/usr/local/src/hadoop-1.2.1/contrib/streaming/hadoop-streaming-1.2.1.jar"

INPUT_FILE_PATH_A="/aaa.txt"

OUTPUT_SORT_PATH="/output_sort"

$HADOOP_CMD fs -rmr -skipTrash $OUTPUT_SORT_PATH

# Step 3.
$HADOOP_CMD jar $STREAM_JAR_PATH \
    -input $INPUT_FILE_PATH_A \
    -output $OUTPUT_SORT_PATH \
    -mapper "cat" \
    -reducer "cat" \
    -jobconf stream.num.map.output.key.fields=3 \
    -jobconf stream.map.output.field.separator=. \
    -jobconf mapred.text.key.partitioner.options=-k2,3 \
    -jobconf mapred.reduce.tasks=3


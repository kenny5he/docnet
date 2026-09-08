set -e -x

HADOOP_CMD="/usr/local/src/hadoop-1.2.1/bin/hadoop"
STREAM_JAR_PATH="/usr/local/src/hadoop-1.2.1/contrib/streaming/hadoop-streaming-1.2.1.jar"

INPUT_FILE_PATH_A="/a.txt"
INPUT_FILE_PATH_B="/b.txt"

OUTPUT_A_PATH="/output_a"
OUTPUT_B_PATH="/output_b"

OUTPUT_JOIN_PATH="/output_join"

#$HADOOP_CMD fs -rmr -skipTrash $OUTPUT_A_PATH $OUTPUT_B_PATH $OUTPUT_JOIN_PATH
#$HADOOP_CMD fs -rmr -skipTrash $OUTPUT_JOIN_PATH

# Step 1.
$HADOOP_CMD jar $STREAM_JAR_PATH \
    -input $INPUT_FILE_PATH_A \
    -output $OUTPUT_A_PATH \
    -mapper "python map_a.py" \
    -file ./map_a.py \

# Step 2.
$HADOOP_CMD jar $STREAM_JAR_PATH \
    -input $INPUT_FILE_PATH_B \
    -output $OUTPUT_B_PATH \
    -mapper "python map_b.py" \
    -file ./map_b.py \

# Step 3.
$HADOOP_CMD jar $STREAM_JAR_PATH \
    -input $OUTPUT_A_PATH,$OUTPUT_B_PATH \
    -output $OUTPUT_JOIN_PATH \
    -mapper "cat" \
    -reducer "python red_join.py" \
    -file ./map_join.py \
    -file ./red_join.py \
    -jobconf stream.num.map.output.key.fields=2 \
    -jobconf num.key.fields.for.partition=1

import ballerina/io;


function main(string... args) {
    var sourceChannel = getFileCharacterChannel("test.json",io:READ, "UTF-8");
    var destinationChannel = getFileCharacterChannel("test2.json",io:WRITE, "UTF-8");
    try {
        process(sourceChannel, destinationChannel);
        io:println("File processing complete.");
    } catch (error err) {
        io:println("error occurred while processing chars " + err.message);
    } finally {
        match sourceChannel.close() {
            error sourceCloseError => {
                io:println("Error occured while closing the channel: " +
                            sourceCloseError.message);
            }
            () => {
                io:println("Source channel closed successfully.");
            }
        }
        match destinationChannel.close() {
            error destinationCloseError => {
                io:println("Error occured while closing the channel: " +
                            destinationCloseError.message);
            }
            () => {
                io:println("Destination channel closed successfully.");
            }
        }
    }
}

function getFileCharacterChannel(string filePath, io:Mode permission,
                                 string encoding) returns io:CharacterChannel {
    io:ByteChannel channel = io:openFile(filePath, permission);
    io:CharacterChannel charChannel = new(channel, encoding);
    return charChannel;
}
function readCharacters(io:CharacterChannel channel,
                        int numberOfChars) returns string {
    match channel.read(numberOfChars) {
        string characters => {
            return characters;
        }
        error err => {
            throw err;
        }
    }
}
function writeCharacters(io:CharacterChannel channel, string content,
                         int startOffset) {
    match channel.write(content, startOffset) {
        int numberOfCharsWritten => {
            io:println(" No of characters written : " + numberOfCharsWritten);
        }
        error err => {
            throw err;
        }
    }
}
function process(io:CharacterChannel sourceChannel,
                 io:CharacterChannel destinationChannel) {
    try {
        string startChar = " { ";
        string endChar = " } ";
         string com = " , ";

        string sourceContent = readCharacters(sourceChannel, 1000);
        writeCharacters(destinationChannel, startChar, 0);
        foreach i in 1 ... 100 {
            writeCharacters(destinationChannel, sourceContent, 0);
            if(i!= 100)
            {
                writeCharacters(destinationChannel, com, 0);
            }
        }
        writeCharacters(destinationChannel, endChar, 1);
    } catch (error err) {
        throw err;
    }
}
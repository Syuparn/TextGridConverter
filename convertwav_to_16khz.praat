##change sampling rate of .wav to 16kHz

clearinfo

directory$ = "dir/to/path"
@convertAllWav: directory$, 16000, 1


##call convertWav recersively

procedure convertAllWav: .directory$, .resampleRate, .nestDepth
	.directory$['.nestDepth'] = .directory$

	# convert wav files in current directory
	@convertWav: .directory$['.nestDepth'], .resampleRate
	
	#search inner directories
	.listname$ = "dir" + .directory$['.nestDepth']
	.strings['.nestDepth'] = Create Strings as directory list: .listname$, .directory$['.nestDepth']
	.numDirectories['.nestDepth'] = Get number of strings

	for .i['.nestDepth'] to .numDirectories['.nestDepth']
		selectObject: .strings['.nestDepth']
		.innerDirectoryName$ = Get string: .i['.nestDepth']
		.curDirectory$ = .directory$['.nestDepth'] + "/" + .innerDirectoryName$
		@convertAllWav: .curDirectory$, .resampleRate, .nestDepth + 1
	endfor
	.nestDepth -= 1
endproc


##resample .wav files in .directory$ by .resampleRate

procedure convertWav: .directory$, .resampleRate
	#make list object, which contains .wav file names
	.listName$ = "wav" + .directory$
	.strings = Create Strings as file list: .listName$, .directory$ + "/*.wav"
	.numFiles = Get number of strings

	for .i to .numFiles
    		selectObject: .strings
    		.fileName$ = Get string: .i
    		Read from file: .directory$ + "/" + .fileName$
    
    		#resample wav file
    		Resample: .resampleRate, 50
		appendInfoLine: .directory$ + "/" + .fileName$
    		nowarn Save as WAV file: .directory$ + "/" + .fileName$
	endfor
endproc

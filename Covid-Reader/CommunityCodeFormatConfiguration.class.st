Class {
	#name : #CommunityCodeFormatConfiguration,
	#superclass : #Object,
	#category : #'Covid-Reader'
}

{ #category : #processing }
CommunityCodeFormatConfiguration >> apply [

	BIConfigurableFormatter
		maxLineLength: 100;
		useBasicCommentFormat: true;
		formatCommentWithStatements: true;
		indentString: Character tab asString;
		"Signature"
		methodSignatureOnMultipleLines: true;
		selectorAndArgumentCombinedMaxSize: 40;
		"Blocks"
		keepBlockInMessage: true;
		lineUpBlockBrackets: true;
		"Keywords"
		oneLineMessages: '#(#to: #to:do: #to:by: #to:by:do:)';
		multiLineMessages: '#(#ifTrue:ifFalse: #ifFalse:ifTrue: #ifTrue: #ifFalse: #on:do: #ensure: #ifCurtailed:)';
		newLineBeforeFirstKeyword: false;
		indentsForKeywords: 1;
		"Line Breaks"
		newLinesAfterMethodComment: 2;
		newLinesAfterMethodPattern: 2;
		newLinesAfterTemporaries: 2;
		minimumNewLinesBetweenStatements: 1;
		retainBlankLinesBetweenStatements: true;
		retainBlankLinesBeforeComments: false;
		"General"
		periodsAtEndOfBlock: false;
		periodsAtEndOfMethod: false;
		stringFollowingReturn: Character space asString;
		stringInsideBlocks: Character space asString;
		stringInsideParentheses: Character space asString;
		"Parentheses"
		useTraditionalBinaryPrecedenceForParentheses: true;
		traditionalBinaryPrecedenceArray: '#(#($| $& $?) #($= $~ $< $>) #($- $+) #($* $/ $% $\) #($@))';
		"Cascades"
		newLineAfterCascade: true;
		newLineBeforeFirstCascade: true
]

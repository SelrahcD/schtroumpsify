<?php

$sentence = isset($_POST['sentence']) ? "'".str_replace("'", "'\\''", $_POST['sentence'])."'" : '';

$start = microtime(true);

$cmd = ". /root/exportbuild/sbin/setenv.sh && echo :conll $sentence | /root/frmg/frmg_shell --quiet";

$time = microtime(true) - $start;

$output = utf8_encode(shell_exec($cmd));

preg_match_all("/^\d.*$/m",$output,$matches);

$tokens = [];

foreach($matches[0] as $line) {

    list($id, $form, $lemma, $pos, $cpos, $mstags, $head, $deprel)= preg_split("/[\s,]+/", $line);

    $mstags = explode('|', $mstags);
    $mstags = array_reduce($mstags, function($mstags, $tag) {

        preg_match('/(.*)=(.*)/', $tag, $matches);

        if(!empty($matches)) {
            $mstags[$matches[1]] = $matches[2];
        }

        return $mstags;
    }, []);

    $tokens[$id] = [
        'id' => $id,
        'form' => $form,
        'lemma' => $lemma,
        'pos' => $pos,
        'cpos' => $cpos,
        'mstag' => $mstags,
        'head' => $head,
        'deprel' => $deprel
    ];
}

header('Content-Type: application/json');

echo json_encode([
    'data' => $tokens,
    'time' => $time,
    'sentence' => $sentence,
]);

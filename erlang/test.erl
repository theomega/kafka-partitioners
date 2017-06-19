%% coding: utf-8

-module(test).
-export([test/0]).

calculatePartition(Key, NumberOfPartitions) ->
  (erlang:crc32(unicode:characters_to_binary(Key, unicode, utf8)) band 16#FFFFFFF) rem NumberOfPartitions.

test() ->
  io:setopts(standard_io, [{encoding, unicode}]),
  Testdata = ["", " ", "abc", "98955f31-2a1f-4c31-b34b-cfd7d8ee2e1e", "7eaf3944-9c1f-42a7-8419-7926a4911ee9", "device1", "de", "device ", "¥"],
  PartitionNumbers =  [1, 2, 16, 32, 128, 256],
  lists:foreach(fun(NumberOfPartitions) ->
    io:fwrite("Test with ~w partitions~n", [NumberOfPartitions]),
    lists:foreach(fun(D) ->
      X = calculatePartition(D, NumberOfPartitions),
      io:fwrite("~ts => ~w~n", [D, X])
    end, Testdata),
    io:fwrite("~n")
  end, PartitionNumbers).

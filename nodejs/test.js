var CRC32 = require("crc-32")

function calculatePartition(key, numberOfPartitions) {
  return (CRC32.str(key) & 0xfffffff) % numberOfPartitions
}

var testData = ['', ' ', 'abc', '98955f31-2a1f-4c31-b34b-cfd7d8ee2e1e', '7eaf3944-9c1f-42a7-8419-7926a4911ee9', 'device1', 'de', 'device ', '¥']
var partitionNumbers = [1, 2, 16, 32, 128, 256]

partitionNumbers.forEach(function(numberOfPartitions) {
  console.log('Test with ' + numberOfPartitions +' partitions')
  testData.forEach(function(d) {
    console.log(d + ' => ' + calculatePartition(d, numberOfPartitions))
  })
  console.log('')
})

import java.util.zip.CRC32;

public class Test {
  public static int calculatePartition(byte[] key, int numberOfPartitions) {
    CRC32 c = new CRC32();
    c.update(key);
    return (int)(c.getValue() & 0xfffffff) % numberOfPartitions;
  }


  private static String[] testData = new String[]{"", " ", "abc", "98955f31-2a1f-4c31-b34b-cfd7d8ee2e1e", "7eaf3944-9c1f-42a7-8419-7926a4911ee9", "device1", "de", "device "};
  private static int[] partitionNumbers = new int[]{1, 2, 16, 32, 128, 256};
  public static void main(String[] args) throws Exception {
    for(int numberOfPartitions: partitionNumbers) {
      System.out.println("Test with " + numberOfPartitions +" partitions");
      for(String d: testData) {
        System.out.println(d + " => " + calculatePartition(d.getBytes("utf-8"), numberOfPartitions));
      }
      System.out.println();
    }
  }
}

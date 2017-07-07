/**
 * Factory for creating Email Utility instances
 */
public class MT_EmailUtilFactory {

  @TestVisible
  public static MT_EmailUtilFactory INSTANCE {
    public get {
      if (INSTANCE == null) {
        INSTANCE = new MT_EmailUtilFactory();
      }
      return INSTANCE;
    }

    private set;
  }


  private MT_EmailUtilFactory() {}
}
public class CheckRecursive {
    private static Integer run = 0;
    public static boolean runOnce() {
        if(run<2) {
            run=run+1;
            return true;
        } else {
            return false;
        }
    }
}
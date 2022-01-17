public class Diferenca<T> extends Conjunto<T> 
{    
    private Conjunto<T> conjunto1 = new ConjuntoVazio<>();
    private Conjunto<T> conjunto2 = new ConjuntoVazio<>();

    public Diferenca(Conjunto<T> c1, Conjunto<T> c2){
        this.conjunto1 = c1;
        this.conjunto2 = c2;
    }

    @Override
    public Boolean contemElemento(T elemento) {
        return conjunto1.contemElemento(elemento) && !conjunto2.contemElemento(elemento);
    }
}

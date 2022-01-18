public class Complemento<T> extends Conjunto<T> 
{
    private Conjunto<T> conjunto1 = new ConjuntoVazio<>();

    public Complemento(Conjunto<T> c1){
        this.conjunto1 = c1;
    }

    @Override
    public Boolean contemElemento(T elemento) {
        return !conjunto1.contemElemento(elemento);
    }
}
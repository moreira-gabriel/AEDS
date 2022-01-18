public class AdicionarElemento<T> extends Conjunto<T> 
{
    private final T valor;

    private final Conjunto<T> conjunto;

    public AdicionarElemento(T valor, Conjunto<T> conjunto)
    {
        this.valor = valor;
        this.conjunto = conjunto;
    }

    @Override
    public Boolean contemElemento(T elemento)
    {
        return elemento == valor || conjunto.contemElemento(elemento);
    }
}
public class ConjuntoVazio<T> extends Conjunto<T> 
{
    @Override
    public Boolean contemElemento(T elemento) 
    {
        return false;
    }
}
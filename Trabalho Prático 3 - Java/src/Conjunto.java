public abstract class Conjunto<T> {
    
    public abstract Boolean contemElemento(T elemento);
    
    Conjunto<T> adicionarElemento(T elemento)
    {
        return new AdicionarElemento<>(elemento, this);
    }
    
    Conjunto<T> uniao(Conjunto<T> conjunto)
    {
        return new Uniao<>(this, conjunto);
    }
    
    Conjunto<T> intersecao(Conjunto<T> conjunto)
    {
        return new Intersecao<>(this, conjunto);
    }
    
    Conjunto<T> diferenca(Conjunto<T> conjunto)
    {
        return new Diferenca<>(this, conjunto);
    }
    
    Conjunto<T> complemento()
    {
        return new Complemento<>(this);
    }
}

class ConjuntoVazio<T> extends Conjunto<T> 
{
    @Override
    public Boolean contemElemento(T elemento) 
    {
        return false;
    }
}

class AdicionarElemento<T> extends Conjunto<T> 
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

class Uniao<T> extends Conjunto<T> 
{
    private Conjunto<T> conjunto1 = new ConjuntoVazio<>();
    private Conjunto<T> conjunto2 = new ConjuntoVazio<>();

    public Uniao(Conjunto<T> c1, Conjunto<T> c2){
        this.conjunto1 = c1;
        this.conjunto2 = c2;
    }

    @Override
    public Boolean contemElemento(T elemento) {
        return conjunto1.contemElemento(elemento) || conjunto2.contemElemento(elemento);
    }
}

class Intersecao<T> extends Conjunto<T> 
{
    private Conjunto<T> conjunto1 = new ConjuntoVazio<>();
    private Conjunto<T> conjunto2 = new ConjuntoVazio<>();

    public Intersecao(Conjunto<T> c1, Conjunto<T> c2)
    {
        this.conjunto1 = c1;
        this.conjunto2 = c2;
    }

    @Override
    public Boolean contemElemento(T elemento)
    {
        return conjunto1.contemElemento(elemento) && conjunto2.contemElemento(elemento);
    }
}

class Diferenca<T> extends Conjunto<T> 
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

class Complemento<T> extends Conjunto<T> 
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

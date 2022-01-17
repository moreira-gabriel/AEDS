/*==================================*/
/*   Trabalho Prático 2 de AEDS     */
/*   Professor: Lucas Alves         */
/*   Aluno: Gabriel Moreira Silva   */
/*   Turma: 203                     */
/*==================================*/

//Variáveis Globais do grid
int gridSize = 15;
int[][] gridGlobal;

//Valores na Matriz
int nothingValue = 0;
int wallValue = 255;
int goalValue = 1;
int playerValue = 254;

//Posições do player e da goal
int playerPositionX;
int playerPositionY;
int goalPositionX;
int goalPositionY;

//Variáveis de procura
int minimumNode = 250;
int minNodeLocation = 250;
int newState = 1;
int resetMin = 250;

// =====================================
// Funções Principais
//======================================
void setup() 
{
   //Define tamanho da tela
   size(800, 800);

   // Imprime a tela inicial
   telaInicial();

   // Inicia a tela de execução e 
   iniciaTelaDeExecucao();
}

void draw() 
{
   delay(1000);
   wavefrontMovement();
}

//==========================================================
// Funcão que cria o grid e coloca as respectivas posições
//==========================================================
int[][] criaMapa(int tam)
{
   //define grid = matr[tam][tam]
   int[][] grid = new int[tam][tam];

   float gridWidth = width/tam;
   float gridHeight = height/tam;

   //preenche o grid com 0 = livre
   for(int i = 0; i < tam; i++)
   {
      for (int j = 0; j < tam; j++) 
      {
         grid[i][j] = nothingValue;
      }
   }

   //Sorteia posição do player e do goal
   boolean continua = true;
   do
   {
      //sorteia posição do player
      int playerPosX = (int)random(tam);
      int playerPosY = (int)random(tam);

      //Sorteia Goal
      int goalPosX = (int)random(tam);
      int goalPosY = (int)random(tam);

      //variaveis de verificação
      boolean goalPlaced = false, playerPlaced = false;

      //coloca o player
      if(grid[playerPosX][playerPosY] == nothingValue) 
      {
         if(playerPosX != goalPosX && playerPosY != goalPosY)
         {
            grid[playerPosX][playerPosY] = playerValue;
         }
      }

      //coloca a goal
      if(grid[goalPosX][goalPosY] == nothingValue)
      {
         if(playerPosX != goalPosX && playerPosY != goalPosY)
         {
            grid[goalPosX][goalPosY] = goalValue;
         }
      }

      //verifica se os dois foram colocados
      for (int i = 0; i < gridSize; i++) 
      {
         for (int j = 0; j < gridSize; ++j) 
         {
            if(grid[i][j] == goalValue) goalPlaced = true;
            if(grid[i][j] == playerValue) playerPlaced = true;
         }
      }

      //condições para sair do do-while -> player e goal devidamente colocados
      if(goalPlaced == true && playerPlaced == true) continua = false;
      else if(goalPlaced == false || playerPlaced == false) continua = true;
      else continua = true;

   }
   while(continua);

   //coloca 2.5 vezes o tamanho em obstaculos
   for(int i = 0; i < (int)(tam*2.5); i++)
   {
      //sorteia x e y do obstaculo
      int posX = (int)random(tam);
      int posY = (int)random(tam);
      
      //se a posição estiver livre, coloca -1 = obstaculo
      //se já tiver um obstaculo, faz o loop +1 vez
      if(grid[posX][posY] == nothingValue)
      {
         grid[posX][posY] = wallValue;
      }
      else i--;
   }

   //retorna grid
   return grid;
}

//=======================//
// Funções do Wave Front //
//=======================//
void wavefrontMovement()
{
   //verifica para onde o player deve ir
   if(gridGlobal[playerPositionX][playerPositionY] != goalValue)
   {
      newState = propagateWavefront(playerPositionX, playerPositionY);
      
      //Move para cima
      if(newState == 1)
      {
         playerPositionX--;
      }

      //Move para a direita
      if(newState == 2)
      {
         playerPositionY++;
      }

      //Move para baixo
      if (newState == 3)
		{
			playerPositionX++;
		}

      //Move para esquerda
		if (newState == 4)
		{
			playerPositionY--;
		}

      //salva o frame
      saveFrame("wavefront-####.png");
   }
}

int propagateWavefront(int playerX, int playerY)
{
   //limpa e atualiza as posições
   unpropagateWavefront(playerPositionX, playerPositionY);


   gridGlobal[goalPositionX][goalPositionY] = goalValue;

   int counter = 0;

   //verifica e coloca os devidos valores dentro de cada espaço da matriz
   while(counter < 50)
   {
      int x = 0;
      int y = 0;

      while(x < gridSize && y < gridSize)
      {
         if(gridGlobal[x][y] != wallValue && gridGlobal[x][y] != goalValue)
         {
            if(verificaValoresPorPerto(x, y) < resetMin && gridGlobal[x][y] == playerValue)
            {
               imprimeGridAtualizado();
               return minNodeLocation;
            }
            else if(minimumNode != resetMin)
            {
               gridGlobal[x][y] = minimumNode + 1;
            }
         }

         y++;

         if(y == gridSize && x != gridSize)
         {
            x++;
            y = 0;
         }
      }

   }
   
   return 0;
}

void unpropagateWavefront(int playerX, int playerY)
{
   //limpa espaços que não serão usados
   for(int x = 0; x < gridSize; x++)
   {
      for(int y = 0; y < gridSize; y++)
      {
         if(gridGlobal[x][y] != wallValue && gridGlobal[x][y] != goalValue)
         {
            gridGlobal[x][y] = nothingValue;
         }
      }
   }
   
   gridGlobal[playerPositionX][playerPositionY] = playerValue;
}

int verificaValoresPorPerto(int x, int y)
{
	minimumNode = resetMin;

   //Cima
   if(x > 0)
   {
      if(gridGlobal[x - 1][y] < minimumNode && gridGlobal[x - 1][y] != nothingValue)
      {
         minimumNode = gridGlobal[x - 1][y];
         minNodeLocation = 1;
      }
   }

	//Direita
	if (y < (gridSize - 1))
   {
		if (gridGlobal[x][y + 1] < minimumNode && gridGlobal[x][y + 1] != nothingValue)
		{
			minimumNode = gridGlobal[x][y + 1];
			minNodeLocation = 2;
		}
   }

   //Baixo
   if(x < (gridSize - 1))
   {
      if(gridGlobal[x + 1][y] < minimumNode && gridGlobal[x + 1][y] != nothingValue)
      {
         minimumNode = gridGlobal[x + 1][y];
         minNodeLocation = 3;
      }
   }

	//Esquerda
	if (y > 0)
   {
		if (gridGlobal[x][y - 1] < minimumNode && gridGlobal[x][y - 1] != nothingValue)
		{
			minimumNode = gridGlobal[x][y - 1];
			minNodeLocation = 4;
		}
   }

	return minimumNode;
}

//========================================================//
// Funções de Impressão / Atualização / Coloração do grid //
//========================================================//
void imprimeGridNoConsole()
{
   for(int x = 0; x < gridSize; x++)
   {
      for (int y = 0; y < gridSize; ++y) 
      {
         print(gridGlobal[x][y], ' ');   
      }
      
      print("\n");
   }
}

void imprimeGridAtualizado()
{
   //Define tamanho de cada quadrado do grid
   float gridHeight = height/gridSize;
   float gridWidth = width/gridSize;

   //Define as cores de acordo com o valor
   for(int i = 0; i < gridSize; i++)
   {
      for (int j = 0; j < gridSize; j++) 
      {
         float y = i*gridHeight;
         float x = j*gridWidth;

         if(gridGlobal[i][j] == wallValue) fill(#ffff00);        //Obstaculo
         else if(gridGlobal[i][j] == nothingValue) fill(255);    //Espaco Livre
         else if(gridGlobal[i][j] == playerValue) fill(#FF0000); //Player
         else if(gridGlobal[i][j] == goalValue) fill(#008000);   //Goal
         else fill(#ADD8E6);;

         //Desenha as linhas quadriculadas
         rect(x, y, gridWidth, gridHeight);
         fill(0);

         // Imprime o valor de cada quadrado em seu respectivo lugar
         //Ajusta tamanho da letra de acordo com o tamanho do grid
         if(gridSize > 0 && gridSize <= 10) textSize(20);
         else if(gridSize > 10 && gridSize <= 20) textSize(15);
         else if(gridSize > 20 && gridSize <= 30) textSize(10);
         else if(gridSize >= 50) textSize(5);
         
         textAlign(CENTER,CENTER);
         text(gridGlobal[i][j], x+gridWidth/2, y+gridHeight/2);
      }
   }
}

//===================================================
//Retornos de valores da posição (goal e player)
//===================================================
int returnPlayerPositionX(int[][] grid)
{
   for (int i = 0; i < gridSize; i++) 
   {
      for (int j = 0; j < gridSize; j++) 
      {
         if(grid[i][j] == playerValue) return i;
      }
   }

   print("erro ao buscar posicao");
   return -1; //erro
}

int returnPlayerPositionY(int[][] grid)
{
   for (int i = 0; i < gridSize; i++) 
   {
      for (int j = 0; j < gridSize; ++j) 
      {
         if(grid[i][j] == playerValue) return j; 
      }
   }

   print("erro ao buscar posicao");
   return -1; //erro
}

int returnGoalPositionX(int[][] grid)
{
   for (int i = 0; i < gridSize; i++) 
   {
      for (int j = 0; j < gridSize; j++) 
      {
         if(grid[i][j] == goalValue) return i; 
      }
   }

   print("erro ao buscar posicao");
   return -1; //erro
}

int returnGoalPositionY(int[][] grid)
{
   for (int i = 0; i < gridSize; i++) 
   {
      for (int j = 0; j < gridSize; j++) 
      {
         if(grid[i][j] == goalValue) return j; 
      }
   }

   print("erro ao buscar posicao");
   return -1; //erro
}

//===================================================
//Outras telas/estados do Programa
//===================================================
void iniciaTelaDeExecucao()
{
   //Cria mapa global
   gridGlobal = criaMapa(gridSize);

   //Pega as posições do player e do goal
   playerPositionX = returnPlayerPositionX(gridGlobal);
   playerPositionY = returnPlayerPositionY(gridGlobal);
   goalPositionX = returnGoalPositionX(gridGlobal);
   goalPositionY = returnGoalPositionY(gridGlobal);
   
   //Imprime as posições no console
   print("Player Position: ", "\n x: ", playerPositionX, " y: ", playerPositionY, "\n");
   print("Goal Position:", "\n x: ", goalPositionX, " y: ", goalPositionY, "\n");
   
   //Imprime grid no console (Opcional)
   // imprimeGridNoConsole();
}

void telaInicial()
{
   background(#0f0f0f);

   textSize(50);
   textAlign(CENTER);
   fill(255, 0, 0);
   text("TRABALHO PRÁTICO 2\nAEDS", width/2, height/4);
   
   textSize(40);
   fill(0,255,0);
   text("Gabriel Moreira Silva\n203", width/2, height/2);
   
   textSize(40);
   fill(0, 0, 255);
   text("Professor: Lucas Alves", width/2, (height/2) + 200);
}

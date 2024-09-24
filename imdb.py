import mysql.connector
from prettytable import PrettyTable

# Conectare la baza de date
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="1234",
    database="imdb"
)

cursor = conn.cursor()


# Functie pentru a obtine o lista de tabele disponibile in baza de date
def get_table_list():
    cursor.execute("SHOW TABLES")
    return [table[0] for table in cursor.fetchall()]


# Functie pentru a afisa meniul de selectie a tabelului
def select_table():
    tables = get_table_list()
    print("\n--- Alegeti un tabel ---")
    for i, table in enumerate(tables, start=1):
        print(f"{i}. {table}")

    while True:
        try:
            choice = int(input("Introduceti numarul corespunzator tabelului: "))
            if 1 <= choice <= len(tables):
                return tables[choice - 1]
            else:
                print("Selectare invalida. Va rugam sa introduceti un numar valid.")
        except ValueError:
            print("Selectare invalida. Va rugam sa introduceti un numar valid.")


# Functie pentru a afisa datele dintr-un tabel
def display_table_data(table_name):
    execute_query(f"SELECT * FROM {table_name}", sort_column=True)


def execute_query(query, sort_column=None):
    cursor.execute(query)
    result = cursor.fetchall()

    # Sortare rezultate în funcție de coloana specificată, dacă este specificată
    if sort_column is not None:
        columns = [desc[0] for desc in cursor.description]
        print("\nAlegeti coloana pentru sortare:")
        for i, col in enumerate(columns, start=1):
            print(f"{i}. {col}")
        try:
            choice = int(input("Introduceti numarul corespunzator coloanei de sortare (0 pentru nesortare): "))
            if 0 < choice <= len(columns):
                result.sort(key=lambda x: x[choice - 1] if x[choice - 1] is not None else '')
            else:
                print("Sortare neselectata.")
        except ValueError:
            print("Sortare neselectata.")

    # Afisare rezultate cu PrettyTable
    if result:
        table = PrettyTable(cursor.column_names)
        for row in result:
            table.add_row(row)
        print(table)
    else:
        print("Nu exista rezultate pentru cererea data.")


# Functie pentru a edita o inregistrare dintr-un tabel
def edit_record(table_name):
    cursor.execute(f"SHOW KEYS FROM {table_name} WHERE Key_name = 'PRIMARY'")
    primary_key_column = cursor.fetchone()[4]

    cursor.execute(f"DESCRIBE {table_name}")
    columns = [column[0] for column in cursor.fetchall()]

    # Exclud coloana cheie primară din coloanele editabile
    editable_columns = [col for col in columns if col != primary_key_column]

    # Afisare nume coloane disponibile pentru editare
    print(f"Coloane disponibile pentru editare in tabela '{table_name}':")
    for i, col in enumerate(editable_columns, start=1):
        print(f"{i}. {col}")

    # Introducere ID inregistrare
    record_id = int(input(f"Introduceti ID-ul inregistrarii din tabela '{table_name}' pentru editare: "))

    # Obtinere valori curente ale inregistrarii
    cursor.execute(f"SELECT * FROM {table_name} WHERE {primary_key_column} = %s", (record_id,))
    current_values = cursor.fetchone()

    # Editare automata a fiecarei coloane
    for col, value in zip(editable_columns, current_values):
        edit_choice = input(f"Doriti sa modificati valoarea pentru coloana '{col}'? (Da/Nu): ")
        if edit_choice.lower() == 'da':
            new_value = input(f"Introduceti noua valoare pentru coloana '{col}': ")

            # Executare interogare de actualizare a coloanei alese pentru inregistrarea specificata
            update_query = f"UPDATE {table_name} SET {col} = %s WHERE {primary_key_column} = %s"
            try:
                cursor.execute(update_query, (new_value, record_id))
                conn.commit()
                print(f"Valoarea pentru coloana '{col}' actualizata cu succes in tabela '{table_name}'.")
            except mysql.connector.Error as err:
                print(f"Error: {err}")
        else:
            print(f"Nu s-a modificat valoarea pentru coloana '{col}'.")

    print(f"Inregistrare actualizata cu succes in tabela '{table_name}'.")


# Functie pentru a sterge o inregistrare dintr-o tabela specificata
def delete_record(table_name):
    cursor.execute(f"SHOW KEYS FROM {table_name} WHERE Key_name = 'PRIMARY'")
    primary_key_info = cursor.fetchone()

    if primary_key_info:
        primary_key_column = primary_key_info[4]

        record_id = int(input(f"Introduceti ID-ul inregistrarii din tabela '{table_name}' pentru stergere: "))

        delete_query = f"DELETE FROM {table_name} WHERE {primary_key_column} = %s"
        try:
            cursor.execute(delete_query, (record_id,))
            conn.commit()
            print(f"Inregistrare stearsa cu succes din tabela '{table_name}'.")
        except mysql.connector.Error as err:
            print(f"Error: {err}")
    else:
        print(f"Nu s-a găsit nicio cheie primară pentru tabela '{table_name}'.")



# Functie pentru afisarea rezultatului unei cereri complexe
def cerere_complexa():
    print("\n--- Cerere complexa ---")

    # Introducerea numelui persoanei
    nume_persoana = input("Introduceti numele persoanei pentru filtrare: ")

    # Introducerea genului filmului
    gen_film = input("Introduceti genul filmului pentru filtrare: ")

    # Construirea si executarea cererii SQL
    query_text = (
        f"SELECT f.nume AS Nume_Film, p.nume AS Nume_Persoana, p.prenume AS Prenume_Persoana, "
        f" g.tip AS Gen_Film "
        f"FROM filme AS f "
        f"JOIN participare_in_film AS pf ON f.id_film = pf.film_id "
        f"JOIN persoane AS p ON pf.persoana_id = p.id_persoana "
        f"JOIN filme_genuri AS fg ON f.id_film = fg.film_id "
        f"JOIN genuri AS g ON fg.gen_id = g.id_gen "
        f"WHERE p.nume = '{nume_persoana}' AND g.tip = '{gen_film}'"
    )

    # Executare cerere
    execute_query(query_text)


# Functie pentru afisarea rezultatului unei interogari folosind GROUP BY si HAVING
def interogare_group_by_having():
    try:
        # Construim și executam interogarea SQL
        query_text = """ SELECT nume AS Cinematograf, COUNT(id_cinematograf) AS NumarCinematografe
                        FROM cinematografe
                        GROUP BY nume
                        HAVING COUNT(id_cinematograf) > 1;
                     """

        cursor.execute(query_text)
        result = cursor.fetchall()

        # Afisare rezultate cu PrettyTable
        if result:
            columns = [desc[0] for desc in cursor.description]
            table = PrettyTable(columns)
            for row in result:
                table.add_row(row)
            print(table)
        else:
            print("Nu exista rezultate pentru cererea data.")

    except Exception as e:
        print(f"Error: {e}")




# Meniu interactiv
while True:
    print("\n--- Meniu Interactiv ---")
    print("0. Iesire din program")
    print("1. Afisare datele dintr-un tabel")
    print("2. Editare inregistrare dintr-un tabel")
    print("3. Stergere inregistrare dintr-un tabel")
    print("4. Cerere complexa")
    print("5. Interogare GROUP BY si HAVING")

    option = input("Alegeti optiunea (0-5): ")

    if option == '0':
        break
    elif option == '1':
        # Afisare datele dintr-un tabel
        table_name = select_table()
        display_table_data(table_name)
    elif option == '2':
        # Editare inregistrare dintr-un tabel
        table_name = select_table()
        edit_record(table_name)
    elif option == '3':
        # Stergere inregistrare dintr-un tabel
        table_name = select_table()
        delete_record(table_name)
    elif option == '4':
        # Cerere complexa
        cerere_complexa()
    elif option == '5':
        # Interogare GROUP BY si HAVING
        interogare_group_by_having()
    else:
        print("Optiune invalida. Va rugam sa introduceti o optiune valida.")

# Inchide conexiunea
cursor.close()
conn.close()

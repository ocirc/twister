#OK a] 4pts.pdb	# 4 atomy wok� pionowej osi
# b] wczytywanie pdb i wypisywanie wsp�rz�dnych
# c] zapisywanie pdb
# d] wizualizacja (pymol non-iteractive, albo znale�� inny renderer pdb)
# e] transformacja do wsp�rz�dnych p�polarnych (r=x^2+z^2; a=atan(z/x))
#f] obr�t wszystkiego o jednakowy k�t
#g] normalizacja wsp�rz�dnych Y (koniec_A = 1.0, koniec_B=-1.0; 0 w �rodku odleg�o�ci, |y_cor|>1.0 dla atom�w dalszych ni� ko�ce)
#h] obr�t o k�t zale�ny od y_cor (w�a�ciwa transformacja)
# ] <MATEMATYKA: jaki typ funkcji przej�cia (k�t(y_cor)) b�dzie najlepszy (liniowy, exp, tan, x^3,...?)>
#i] odnajdywanie osi
#j] normalizacja i denormalizacja Y

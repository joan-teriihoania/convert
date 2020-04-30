# Présentation
La commande `convert` est un utilitaire de commande externe permettant de convertir un fichier **markdown (github)** en PDF en reformattant le texte via une syntaxe **Latex** intermédiaire. Cet utilitaire permet ainsi de générer des rapports en utilisant la syntaxe relativement simple de **Markdown**.

Cette commande converti tout fichier .md en mardown de github en PDF en utilisant une conversion vers un format Latex. Elle utilise pandoc, un script python et pdflatex. Par défaut, la commande téléchargera un fichier Main.tex dans le dossier temporaire qui sera le fichier Latex racine. Ce dernier inclut les tags d'initialisation, la page de garde et la table des matères générée par Latex automatiquement. Le fichier Latex racine est un modèle. Vous êtes libre de le modifier. Notez que si le fichier Main.tex est introuvable, il sera retéléchargé et réinitialisé.

> **Note :** Le système de version se base sur le Unix Timestamp de la dernière édition du fichier `convert.bat` du serveur. Ainsi, lorsqu'une modification se produit, la version change automatiquement. Il ne s'agit donc pas d'un système de version itératif.

# Prérequis
## Commandes externes
Afin de fonctionner, `convert` requière plusieurs commandes externes :
- [pandoc](https://pandoc.org/)
- [python](https://www.python.org/) sous l'alias py
- [powershell](https://docs.microsoft.com/fr-fr/powershell/)
- [pdflatex](https://miktex.org/) de miktex

## Environnement compatible
Cette commande a été développée sous Windows 10 64 bits. Aucun autre environnement n'a pu être testé. Néanmoins, les environnements Linux et MAC OS ne sont pas compatibles.

# Installation
## Téléchargement
Vous pouvez télécharger `convert` (*dernière version*) en allant [ici](https://joan-teriihoania.fr/updater/download.php?filename=convert.bat&download=true).
> **Important :** Les versions antérieures sont écrasées et effacées. Si une mise à jour échoue, téléchargez la nouvelle version depuis le lien précédent.

## Installation
L'installation de la commande est automatique. Les fichiers auxiliaires requis seront téléchargés par la commande, elle demande donc une connexion internet pour être installée. En cas d'échec d'installation, un message spécifiant la nature de l'erreur sera affiché.

L'installation des commandes externes (`pandoc`, `python`, `powershell`) est de votre ressort, néanmoins, la commande `pdflatex` peut être installée à partir de la version **1586935773** depuis `convert` en utilisant l'option `--install-pdflatex`. L'installation peut prendre plusieurs minutes en fonction de votre connexion internet et peut occuper un espace disque relatif (à consulter sur le site de [Miktex](https://miktex.org/)).

> **Note :** L'installation se fait en local (elle n'est pas intégrée aux variables d'environnement et ne pourra être utilisée qu'à l'intérieur du dossier installé) pour la version **1586935773**. Cette option impliquant une couche algorithmique supplémentaire, elle sera potentiellement intégrée dans une version ultérieure.

# Utilisation
## Syntaxe
*Extrait de l'aide disponible via l'option `/?` de la commande à la version 1586935773.*

```
Syntax: convert <Input filename> <Output filename> [option]
Syntax: convert [option]
  Input filename  : Name of the input file.
  Output filename : Name of the file which will receive the result of the
                    conversion without extension.

Options :
  --overwrite        : Option to overwrite, disabled by default, the contentof any file
                       named as the given output filename with the result of the conversion.
  --update           : Update the command to the latest release.
  --force-update     : Force the update even if the version is already up-to-date.
  --check-update     : Search for the latest release.
  --version          : Stop the execution to only display the version header.
  --temp-reset       : Delete all files within the temp folder.
  --install-pdflatex : Install pdflatex (Miktex).
```

## Erreurs
Lorsqu'une erreur de fonctionnement lors de la conversion se produit, un code d'erreur sera affiché. Ce code permet d'identifier l'erreur en question. Vous pouvez trouver l'identifiant de l'erreur en fonction de son code en utilisant l'option `/?`. *Voici un extrait de l'aide sur l'index d'erreur de la commande à la version 1586235773 :*

```
Error codes index:
  [0] The process ended without any errors.
  [1] The process couldn't find the given input filename.
  [2] The conversion failed to LATEX from GITHUB MARKDOWN or the outputed result/file
      from the conversion couldn't be found by the process.
  [3] The process found a file already named as the given output PDF filename.
  [4] The conversion failed to PDF from LATEX or the outputed result/file
      from the conversion couldn't be found by the process.
  [5] The Main.tex file used for the generation of PDF could not be found and downloaded.
  [6] The format.py script used to reformat Latex file could not be found and downloaded.
  [7] One the following required command is not installed :
         - pandoc (https://pandoc.org/)
         - pdflatex (https://miktex.org/)
         - py (https://www.python.org/)
         - powershell (https://docs.microsoft.com/fr-fr/powershell/)
```
--Cleaning Data in SQL Queries 

SELECT*
FROM PortfolioProject..NashvilleHousing
where PropertyAddress is null

--Date Format 

SELECT SaleDate, Convert(Date,SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = Convert(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateChanged Date

UPDATE NashvilleHousing
SET SaleDateChanged = CONVERT(DATE,SaleDate)

SELECT SaleDateChanged, CONVERT(Date, SaleDateChanged)
FROM PortfolioProject..NashvilleHousing

--Populate Property Address Date
SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing A
JOIN PortfolioProject..NashvilleHousing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ] 
WHERE A.PropertyAddress IS NULL

UPDATE A 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing A
JOIN PortfolioProject..NashvilleHousing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ] 
WHERE A.PropertyAddress IS NULL

--Breaking out adress into individual columns (address, city, state)

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing
--WHERE PropertyAddress is null
--ORDER BY ParcelID

SELECT
SUBSTRING(Propertyaddress,1, CHARINDEX(',', PropertyAddress)-1) AS Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(propertyaddress)) AS Address

FROM PortfolioProject..NashvilleHousing


ALTER TABLE NashVilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(propertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashVilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(propertyAddress, CHARINDEX(',', PropertyAddress) +1,  LEN(propertyaddress))

SELECT *
FROM PortfolioProject..NashvilleHousing


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from PortfolioProject..NashvilleHousing


ALTER TABLE NashVilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashVilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashVilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

--Change Y and N to YES and NO in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
    WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant 
	END 
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
    WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant 
	END 


--Remove Duplicates

WITH ROWNUMCTE AS(
SELECT *,
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   ORDER BY 
			    UniqueID
				)Row_Num

FROM PortfolioProject..NashvilleHousing
--ORDER BY ParcelID 
)
SELECT*
FROM RowNumCTE
WHERE Row_Num >1
--ORDER BY PropertyAddress

--DELETE
--FROM RowNumCTE
--WHERE Row_Num >1
----ORDER BY PropertyAddress

--Delete Unused Columns

SELECT*
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate

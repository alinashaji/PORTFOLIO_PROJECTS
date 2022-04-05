SELECT *
FROM Housing.dbo.villahousing

--Standardize Date format

Select saleDateConverted, CONVERT(Date,SaleDate)
From Housing.dbo.villahousing


Update villahousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE villahousing
Add SaleDateConverted Date;

Update villahousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

*************************************
--populate property address data

--#check for null values
SELECT *
From Housing.dbo.villahousing
WHERE PropertyAddress is null
--#there are null values
--Let's try grouping the data based on ParcelID

SELECT *
From Housing.dbo.villahousing
ORDER BY ParcelID
--#We found that parcelID and property Address are connected.So we need to perform a join

SELECT a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Housing.dbo.villahousing a
JOIN Housing.dbo.villahousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Housing.dbo.villahousing a
JOIN Housing.dbo.villahousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null

**********************************************************************************


--Breaking out the address into address , city, 


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From Housing.dbo.villahousing


ALTER TABLE housing.dbo.villahousing
Add PropertySplitAddress Nvarchar(255);

Update housing.dbo.villahousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE housing.dbo.villahousing
Add PropertySplitCity Nvarchar(255);

Update housing.dbo.villahousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

--BREAKING OUT THE OWNER ADDRESS

Select OwnerAddress
From Housing.dbo.villahousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Housing.dbo.villahousing



ALTER TABLE housing.dbo.villahousing
Add OwnerSplitAddress Nvarchar(255);

Update housing.dbo.villahousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE housing.dbo.villahousing
Add OwnerSplitCity Nvarchar(255);

Update housing.dbo.villahousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE housing.dbo.villahousing
Add OwnerSplitState Nvarchar(255);

Update housing.dbo.villahousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


--change y and n to "yes" and "no"

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM housing.dbo.villahousing
GROUP BY SoldAsVacant
ORDER BY 1, 2

SELECT SoldAsVacant,
CASE when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
     ELSE SoldAsVacant
	 END
FROM housing.dbo.villahousing

UPDATE housing.dbo.villahousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
     ELSE SoldAsVacant
	 END

********************************************************************
--Remove duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From housing.dbo.villahousing
--order by ParcelID
)

--Select *
--From RowNumCTE
--Where row_num > 1
--Order by PropertyAddress


DELETE
From RowNumCTE
Where row_num > 1

-- DELETE UNUSED COLUMNS

Select *
From housing.dbo.villahousing


ALTER TABLE housing.dbo.villahousing
DROP COLUMN  TaxDistrict, PropertyAddress, SaleDate
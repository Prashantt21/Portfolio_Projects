-- Cleaning in SQL Queries
Select * 
From PortfolioProject.dbo.NashvilleHousing





--Standardize Date Format
Select SaleDate, CONVERT(date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
Set SaleDate = COnvert (Date,SaleDate) 

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add SaleDateConverted Date;

Update PortfolioProject.dbo.NashvilleHousing
Set SaleDateConverted = COnvert (Date,SaleDate)


--Populate Property Address data
Select *
From PortfolioProject.dbo.NashvilleHousing
--WHere PropertyAddress is null
Order by ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking Address into Individual Coloumns (Address,City,State)
Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--WHere PropertyAddress is null
--Order by ParcelID

SELECT 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertyState nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertyState = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT * 
From PortfolioProject.dbo.NashvilleHousing


SELECT OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


SELECT 
PARSENAME(Replace(OwnerAddress,',','.'),3)
,PARSENAME(Replace(OwnerAddress,',','.'),2)
,PARSENAME(Replace(OwnerAddress,',','.'),1)
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSlplitCity nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSlplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSlplitState nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSlplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

Select * 
FROM PortfolioProject..NashvilleHousing




--Change Y and N to 'Yes' and 'No' in 'Sold as Vacant' field

SELECT Distinct(SoldAsVacant),COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
Group BY SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes'
	   when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProject..NashvilleHousing

Update PortfolioProject..NashvilleHousing
SET SoldAsVacant = Case when SoldAsVacant = 'Y' THEN 'Yes'
		when SoldAsVacant = 'N' THEN 'No'
		Else SoldAsVacant
		END

--Remove Duplicates (NOT A STANDARD PROCEDURE TO DELETE DATA FROM THE SERVER)

SELECT * 
FROM PortfolioProject..NashvilleHousing

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order BY 
					UniqueID
					) row_num
FROM PortfolioProject..NashvilleHousing
--Order by ParcelID
)

--This below code was used to delete the duplicate items in the data.
--DELETE
--From RowNumCTE
--Where row_num > 1
--Order BY PropertyAddress

-- This below code is to check if the duplicates has been deleted or not.
SELECT *
FROM RowNumCTE
WHere row_num >1
Order BY PropertyAddress

-- Delete unused coloumns

SELECT *
FROM PortfolioProject..NashvilleHousing


ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate